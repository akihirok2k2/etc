<?php

    //一字ファイルができているか（アップロードされているか）チェック
    if(is_uploaded_file($_FILES['up_file']['tmp_name'])){

        //一字ファイルを保存ファイルにコピーできたか
        if(move_uploaded_file($_FILES['up_file']['tmp_name'],"./orignal-file/".$_FILES['up_file']['name'])){
            $filename = $_FILES['up_file']['name'];

            //正常
	    $cmd = 'convert ./orignal-file/"'.$filename.'" -resize 128x128 ./slack/slack_"'.$filename.'"';
	    exec($cmd, $opt);
            echo "uploaded : Accsess http://sakura.kanakomi.com/upload/slack/slack_$filename";
            header('Location: ' . "http://sakura.kanakomi.com/upload/slack/slack_$filename", true, 301);

        }else{

            //コピーに失敗（だいたい、ディレクトリがないか、パーミッションエラー）
            echo "error while saving.";
        }

    }else{

        //そもそもファイルが来ていない。
        echo "file not uploaded.";

    }
