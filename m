From: AndyLiebman@aol.com
Subject: Re: mdadm can't start RAID0 volume after power failure
Date: Fri, 17 Dec 2004 12:44:20 EST
Message-ID: <1e1.31adebd6.2ef474f4@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philippe.gramoulle@mmania.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looking at your mdadm.conf file, and at the results of your mdadm -QE --scan, 
I can see that the UUID numbers are different. Which UUID numbers do you get 
when you run mdadm -E /dev/sd{e,f,g,h,i,j,k}1? I tried to follow the web page 
link in your post and I couldn't get to it. Are you trying to start your array 
with the wrong UUID number by chance? 

Regards, 
Andy Liebman

># cat /etc/mdadm/mdadm.conf
>
>DEVICE /dev/sd[efghijk]1
>ARRAY /dev/md0 level=raid0 num-devices=7 
>UUID=46c66ef8:8acf2810:48adb2d3:85b04900
>

>Still, every # mdadm -E /dev/sd[efghijk]1 looks ok, output can be found 
here: >http://philou.org/mdadm.log
>mdadm.conf is here : http://philou.org/mdadm.conf
>
># mdadm -QE --scan
>ARRAY /dev/md0 level=raid0 num-devices=7 
>UUID=3c1ad678:d3a7a1ed:1112143d:68b4e569
