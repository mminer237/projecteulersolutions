<?php

$sides = 4;

$squares = ["GO","A1","CC1","A2","T1","R1","B1","CH1","B2","B3","JAIL","C1","UI","C2","C3","R2","D1","CC2","D2","D3","FP","E1","CH2","E2","E3","R3","F1","F2","U2","F3","G2J","G1","G2","CC3","G3","R4","CH3","H1","T2","H2"];

$ch = ["GO", "JAIL", "C1", "E3", "H2", "R1", "R", "R", "U", "go back 3", null, null, null, null, null, null];
$cch = $ch;
shuffle($cch);

$cc = ["GO", "JAIL", null, null, null, null, null, null, null, null, null, null, null, null, null, null];
$ccc = $cc;
shuffle($ccc);

$pos = array_search("GO", $squares);
$history = array_fill_keys($squares, 0);
$doubles = 0;

for ($i = 0; $i < 1000000; $i++) {
	$roll1 = rand(1, $sides);
	$roll2 = rand(1, $sides);
	if ($roll1 === $roll2)
		$doubles++;
	else
		$doubles = 0;
	if ($doubles === 3) {
		$pos = array_search("JAIL", $squares);
		$history[$squares[$pos]]++;
		continue;
	}
	$pos += $roll1 + $roll2;
	if ($pos >= count($squares))
		$pos -= count($squares);
	switch ($squares[$pos]) {
		case 'G2J':
			$pos = array_search("JAIL", $squares);
			break;
		case 'CH1':
		case 'CH2':
		case 'CH3':
			draw_card("ch");
			break;
		case 'CC1':
		case 'CC2':
		case 'CC3':
			draw_card("cc");
			break;
	}
	$history[$squares[$pos]]++;
}

arsort($history);
foreach (array_slice($history, 0, 3) as $x => $n) {
	echo str_pad(array_search($x, $squares), 2, '0', STR_PAD_LEFT);
}

function draw_card(string $deck_name): void {
	global $pos, $squares, $ch, $cch, $cc, $ccc;
	$current_deck_name = "c$deck_name";
	if (count($$current_deck_name) === 0) {
		$$current_deck_name = $$deck_name;
		shuffle($$current_deck_name);
	}
	$card = array_pop($$current_deck_name);
	if ($card) {
		if (($result = array_search($card, $squares)) !== false)
			$pos = $result;
		elseif ($card === "go back 3") {
			$pos -= 3;
			if ($pos < 0)
				$pos += count($squares);
		}
		else
			go_to_letter($card);
	}
}

function go_to_letter(string $letter): void {
	global $pos, $squares;
	while ($squares[$pos][0] !== $letter) {
		$pos++;
		if ($pos >= count($squares))
			$pos -= count($squares);
	}
}
