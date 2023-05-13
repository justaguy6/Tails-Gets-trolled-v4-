package modchart.modifiers;
import flixel.FlxSprite;
import ui.*;
import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;
import math.*;

class DrunkModifier extends NoteModifier {
    override function getName()return 'drunk';
    
	override function getPos( visualDiff:Float, timeDiff:Float, beat:Float, pos:Vector3, data:Int, player:Int, obj:FlxSprite)
	{
        var drunkPerc = getValue(player);
        var tipsyPerc = getSubmodValue("tipsy",player);
        var bumpyPerc = getSubmodValue("bumpy", player);
        var tipZPerc = getSubmodValue("tipZ", player);
		var drunkZPerc = getSubmodValue("drunkZ", player);
        var time = (Conductor.songPosition/1000);
        if(tipsyPerc!=0){
            var speed = getSubmodValue("tipsySpeed",player);
            var offset = getSubmodValue("tipsyOffset",player);
            pos.y += tipsyPerc * (FlxMath.fastCos((time*((speed*1.2)+1.2) + data*((offset * 1.8)+1.8))) * Note.swagWidth*.4);
        }

        if(drunkPerc!=0){
            var speed = getSubmodValue("drunkSpeed",player);
            var period = getSubmodValue("drunkPeriod",player);
            var offset = getSubmodValue("drunkOffset",player);

            var angle = time * (1+speed) + data*( (offset*0.2) + 0.2)
            + visualDiff * ( (period*10) + 10) / FlxG.height;
            pos.x += drunkPerc * (FlxMath.fastCos(angle) * Note.swagWidth * 0.5);
        }

        if (tipZPerc != 0)
        {
            var speed = getSubmodValue("tipZSpeed", player);
            var offset = getSubmodValue("tipZOffset", player);
			pos.z += tipZPerc * (FlxMath.fastCos((time * ((speed * 1.2) + 1.2) + data * ((offset * 1.8) + 1.8))) * Note.swagWidth * .4);
        }

		if (drunkZPerc != 0)
		{
			var speed = getSubmodValue("drunkZSpeed", player);
			var period = getSubmodValue("drunkZPeriod", player);
			var offset = getSubmodValue("drunkZOffset", player);

			var angle = time * (1 + speed) + data * ((offset * 0.2) + 0.2) + visualDiff * ((period * 10) + 10) / FlxG.height;
			pos.z += drunkZPerc * (FlxMath.fastCos(angle) * Note.swagWidth * 0.5);
		}

        if(bumpyPerc!=0){
            var period = getSubmodValue("bumpyPeriod", player);
            var offset = getSubmodValue("bumpyOffset", player);
            var angle = (visualDiff + (100.0 * offset)) / ((period * 16.0) + 16.0);
            pos.z += (bumpyPerc * 40 * FlxMath.fastSin(angle));
        }


        return pos;
    }

    override function getSubmods(){
        return [
            "tipsy",
            "bumpy",
            "drunkSpeed",
            "drunkOffset",
            "drunkPeriod",
            "tipsySpeed",
            "tipsyOffset",
            "bumpyOffset",
            "bumpyPeriod",

            "tipZ",
            "tipZSpeed",
            "tipZOffset",

            "drunkZ",
            "drunkZSpeed",
            "drunkZOffset",
            "drunkZPeriod"
        ];
    }

}
