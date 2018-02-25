<?php
################# memcached ###################################################
    
    $k=0;
    $t_time=0;
    echo "
Benchmark memcached : 
";
    $memcached = new Memcached;  
    $memcached->addServer("127.0.0.1", 11211)or die ("Cannot connect");  

    $original_string = 'abcdefghijklmnopqrstuvwxyz';    
    for ($i=0;$i<=10000;$i++){
        $random_string = get_random_string($original_string, 10);
        $random_string2 = get_random_string($original_string, 10);
        $a1[$i]=$random_string;
        $a2[$random_string]=$random_string2;
    }    
    $tstart=timer_start();        
    for ($i=0;$i<=10000;$i++){                
        $memcached->set($a1[$i], $a2[$a1[$i]],20) or die ("Cannot save data");
    }
    $t_time=timer_end($tstart);    
    echo "Total Set time: ".$t_time."
";        
    for ($j=0;$j<10;$j++){    
        $tstart=timer_start();    
        for ($i=0;$i<=10000;$i++){            
            $value = $memcached->get($a1[$i]);              
        }    
        $t_time=timer_end($tstart);
        echo "Loop $j (Get) time: ".$t_time."
";        
        $k=$k+$t_time;    
    } 
    echo "Total 10 loop Get time $k 
";    

################# memcache ###################################################

    $k=0;
    $t_time=0;
    echo "
Benchmark memcache : 
";
    $memcache = new Memcache;  
    $memcache->connect('127.0.0.1', 11211) or die ("Cannot connect");  

    $original_string = 'abcdefghijklmnopqrstuvwxyz';    
    for ($i=0;$i<=10000;$i++){
        $random_string = get_random_string($original_string, 10);
        $random_string2 = get_random_string($original_string, 10);
        $a1[$i]=$random_string;
        $a2[$random_string]=$random_string2;
    }    
    $tstart=timer_start();        
    for ($i=0;$i<=10000;$i++){        
        $memcache->set($a1[$i], $a2[$a1[$i]], false, 20) or die ("Cannot save data");
    }
    $t_time=timer_end($tstart);    
    echo "Total Set time: ".$t_time."
";        
    for ($j=0;$j<10;$j++){    
        $tstart=timer_start();    
        for ($i=0;$i<=10000;$i++){            
            $value = $memcache->get($a1[$i]);              
        }    
        $t_time=timer_end($tstart);
        echo "Loop $j (Get) time: ".$t_time."
";        
        $k=$k+$t_time;    
    } 
    echo "Total 10 loop Get time $k 
";

################# redis ###################################################

    $k=0;
    $t_time=0;
    echo "
Benchmark redis 6379: 
";
    $redis = new Redis();
    $redis->connect('127.0.0.1', 6379);
    
    $original_string = 'abcdefghijklmnopqrstuvwxyz';    
    for ($i=0;$i<=10000;$i++){
        $random_string = get_random_string($original_string, 10);
        $random_string2 = get_random_string($original_string, 10);
        $a1[$i]=$random_string;
        $a2[$random_string]=$random_string2;
    }    
    $tstart=timer_start();    
    for ($i=0;$i<=10000;$i++){
        $redis -> set($a1[$i],$a2[$a1[$i]]);        
    }
    $t_time=timer_end($tstart);    
    echo "Total Set time: ".$t_time."
";    
    for ($j=0;$j<10;$j++){
        $tstart=timer_start();        
        for ($i=0;$i<=10000;$i++){            
            $value=$redis -> get($a1[$i]);            
        }
    $t_time=timer_end($tstart);        
    echo "Loop $j (Get) time: ".$t_time."
";
    $k=$k+$t_time;    
    }     
    echo "Total 10 loop Get time $k 
";

################# redis ###################################################

    $k=0;
    $t_time=0;
    echo "
Benchmark redis 6479: 
";
    $redis = new Redis();
    $redis->connect('127.0.0.1', 6479);
    
    $original_string = 'abcdefghijklmnopqrstuvwxyz';    
    for ($i=0;$i<=10000;$i++){
        $random_string = get_random_string($original_string, 10);
        $random_string2 = get_random_string($original_string, 10);
        $a1[$i]=$random_string;
        $a2[$random_string]=$random_string2;
    }    
    $tstart=timer_start();    
    for ($i=0;$i<=10000;$i++){
        $redis -> set($a1[$i],$a2[$a1[$i]]);        
    }
    $t_time=timer_end($tstart);    
    echo "Total Set time: ".$t_time."
";    
    for ($j=0;$j<10;$j++){
        $tstart=timer_start();        
        for ($i=0;$i<=10000;$i++){            
            $value=$redis -> get($a1[$i]);            
        }
    $t_time=timer_end($tstart);        
    echo "Loop $j (Get) time: ".$t_time."
";
    $k=$k+$t_time;    
    }     
    echo "Total 10 loop Get time $k 
";

   

function timer_start()   
{   $time = microtime();
    $time = explode(" ", $time);
    $time = $time[1] + $time[0];
    return $time;    
}   
function timer_end($start)
{   $time = microtime();
    $time = explode(" ", $time);
    $time = $time[1] + $time[0];    
    return $time-$start;    
}
   
function get_random_string($valid_chars, $length)
{   
    // start with an empty random string
    $random_string = "";

    // count the number of chars in the valid chars string so we know how many choices we have
    $num_valid_chars = strlen($valid_chars);

    // repeat the steps until we've created a string of the right length
    for ($i = 0; $i < $length; $i++)
    {
        // pick a random number from 1 up to the number of valid chars
        $random_pick = mt_rand(1, $num_valid_chars);

        // take the random character out of the string of valid chars
        // subtract 1 from $random_pick because strings are indexed starting at 0, and we started picking at 1
        $random_char = $valid_chars[$random_pick-1];

        // add the randomly-chosen char onto the end of our string so far
        $random_string .= $random_char;
    }

    // return our finished random string
    return $random_string;
} 
?>