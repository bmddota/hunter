"use strict";

/* Action-RPG style input handling.

Left click moves or trigger ability 1.
Right click triggers ability 2.
*/


var inAction = false;
var hasMoved = false;

function BeginRangedAttack(targetEntIndex)
{
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer());
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION,
		Position: [0,0,0],
		AbilityIndex : Entities.GetAbility( localHeroIndex , 10 ),
		Queue : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};

	inAction = true;
	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			if (targetEntIndex == null){
				if (GameUI.IsShiftDown()){
					$.Schedule( 1.0/30.0, tic );

					if (Abilities.IsCooldownReady( order.AbilityIndex ) && !Abilities.IsInAbilityPhase( order.AbilityIndex )) {
						order.Position = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
						order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
						Game.PrepareUnitOrders( order );
					}
				}
				else{
					var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
					mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex != localHeroIndex; } )

					if (mouseEntities.length !== 0){
						var currentAttackTarget = null;
						for ( var e of mouseEntities )
						{
							if ( !e.accurateCollision )
								continue;
							BeginRangedAttack( e.entityIndex );
							return;
						}
						if ( currentAttackTarget === null )
						{
							BeginRangedAttack( mouseEntities[0].entityIndex );
						}
					}
					else{
						BeginMoveState();
					}
				}
			}
			else{
				if (GameUI.IsShiftDown()){
					BeginRangedAttack(null);
				}
				else{
					$.Schedule( 1.0/30.0, tic );

					if ( Entities.IsAlive( targetEntIndex) && Abilities.IsCooldownReady( order.AbilityIndex ) && !Abilities.IsInAbilityPhase( order.AbilityIndex )
				&& !Entities.IsInvulnerable( targetEntIndex) ){
						$.Msg("FFFFFFFFFFFFFFFFFFFF");
						order.Position = null;
						order.TargetIndex = targetEntIndex
						order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TARGET;
						Game.PrepareUnitOrders( order );
					}
				}
			}
		}
		else { inAction = false;}
	})();
}
// Tracks the left-button held when attacking a target
function BeginAttackState( targetEntIndex )
{
	$.Msg('BAS');
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex : targetEntIndex,
		AbilityIndex : Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 10 ),
		Queue : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};

	inAction = true;
	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			$.Schedule( 1.0/30.0, tic );
			$.Msg('trying', Entities.IsAlive( order.TargetIndex), Abilities.IsCooldownReady( order.AbilityIndex), !Abilities.IsInAbilityPhase( order.AbilityIndex), Abilities.GetAbilityName(order.AbilityIndex) );
			//$.Msg("hasMoved ", hasMoved);
			if ( Entities.IsAlive( order.TargetIndex) && Abilities.IsCooldownReady( order.AbilityIndex ) && !Abilities.IsInAbilityPhase( order.AbilityIndex )
				&& !Entities.IsInvulnerable( order.TargetIndex) )
			{
				$.Msg("ORDER");
				hasMoved = false;
				order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TARGET;
				Game.PrepareUnitOrders( order );
			}
			else if (hasMoved) {
				hasMoved = false;
				order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_TARGET;
				Game.PrepareUnitOrders( order );
			}
		}
		else { inAction = false;}
	})();
}

// Tracks the left-button held state when moving.
function BeginMoveState()
{
	$.Msg('BMS');
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position : [0, 0, 0],
		Queue : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};

	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	var isRanged = (Abilities.GetBehavior( Entities.GetAbility( localHeroIndex, 10 ) ) & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) !== 0;

	inAction = true;

	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			if (GameUI.IsShiftDown() && isRanged){
				BeginRangedAttack(null);
				return;
			}
			if (GameUI.IsControlDown()){
				order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_DIRECTION;
				var abil = Entities.GetAbility( localHeroIndex, 4 )
				$.Msg(Abilities.GetAbilityName(abil));
				if (!Abilities.IsPassive(abil) && Abilities.IsCooldownReady(abil) && !Abilities.IsInAbilityPhase(abil)){
					order = {
						OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex : abil,
						Queue : false,
						ShowEffects : false
					};
				}
			}else{
				order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_POSITION;
			}

			$.Schedule( 1.0/30.0, tic );
			var mouseWorldPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
			if ( mouseWorldPos !== null )
			{
				order.Position = mouseWorldPos;
				hasMoved = true;
				Game.PrepareUnitOrders( order );
			}
		}
		else{ inAction = false;} 
	})();
}

// Handle Left Button events
function OnLeftButtonPressed()
{
	$.Msg("LEFT BUTTON CAST")

	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	var isRanged = (Abilities.GetBehavior( Entities.GetAbility( localHeroIndex, 10 ) ) & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) !== 0;
	var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex != localHeroIndex; } )
	$.Msg("entities: ", mouseEntities.length)

	$.Msg("RANGED ", isRanged);
	if (isRanged && GameUI.IsShiftDown()){
		BeginRangedAttack(null);
	}
	else if (GameUI.IsControlDown() || mouseEntities.length == 0 )
	{
		BeginMoveState();
	}
	else if (isRanged){
		var currentAttackTarget = null;
		for ( var e of mouseEntities )
		{
			if ( !e.accurateCollision )
				continue;
			BeginRangedAttack( e.entityIndex );
			return;
		}
		if ( currentAttackTarget === null )
		{
			BeginRangedAttack( mouseEntities[0].entityIndex );
		}
	}
	else{	
		var currentAttackTarget = null;
		for ( var e of mouseEntities )
		{
			if ( !e.accurateCollision )
				continue;
			BeginAttackState( e.entityIndex );
			return;
		}
		if ( currentAttackTarget === null )
		{
			BeginAttackState( mouseEntities[0].entityIndex );
		}
	}
}

// Handle Right Button events
function OnRightButtonPressed()
{
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex : Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 11 ),
		Position : [0, 0, 0],
		Queue : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};
	$.Msg("RIGHT BUTTON CAST")

	var mouseWorldPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
	if ( mouseWorldPos !== null )
	{
		order.Position = mouseWorldPos;
		hasMoved = true;
		Game.PrepareUnitOrders( order );
	}
}

/*
var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
var particle = Particles.CreateParticle("particles/ui_mouseactions/range_finder_cone.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, localHeroIndex)
Particles.SetParticleControlEnt(particle, 1, localHeroIndex, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, "follow_origin", [0,0,0], true)
Particles.SetParticleControl(particle, 3, [50,0,0])
var len = function(a,b){return Math.sqrt((a[0]-b[0])*(a[0]-b[0]) + (a[1]-b[1])*(a[1]-b[1]))}
var fun = function(){var mouseWorldPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() ); if ( mouseWorldPos !== null ) { mouseWorldPos[0] = Math.round(mouseWorldPos[0]/64)*64; mouseWorldPos[1] = Math.round(mouseWorldPos[1]/64)*64; var heroPos = Entities.GetAbsOrigin(localHeroIndex); Particles.SetParticleControl(particle, 3, [len(heroPos,mouseWorldPos)/3,0,0]); Particles.SetParticleControl(particle, 2, mouseWorldPos) }; $.Schedule(1/60, fun);}
*/


// Main mouse event callback
GameUI.SetMouseCallback( function( eventName, arg ) {
	var CONSUME_EVENT = true;
	var CONTINUE_PROCESSING_EVENT = false;
	$.Msg("MOUSE: ", eventName, " -- ", arg, " -- ", GameUI.GetClickBehaviors())

	if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
		return CONTINUE_PROCESSING_EVENT;

	if ( eventName === "pressed" || eventName === "doublepressed")
	{
		// Left-click is move to position or attack
		if ( arg === 0 )
		{
			if (GameUI.IsAltDown()) {
				var pos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() )
				if (pos !== null)
					$.Msg('pos: Vector(', pos[0], ', ', pos[1], ', ', pos[2], ')');
				else
					$.Msg("off world click")
			}
			if (inAction){
				$.Msg("IN ACTION");
				return CONSUME_EVENT;
			}
			OnLeftButtonPressed();
			return CONSUME_EVENT;
		}

		// Right-click is use ability #2
		if ( arg === 1 )
		{
			OnRightButtonPressed();
			return CONSUME_EVENT;
		}
	}
	return CONTINUE_PROCESSING_EVENT;
} );


