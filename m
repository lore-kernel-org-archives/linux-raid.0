From: Adam Luter <luterac@bellsouth.net>
Subject: Re: raid 1 vs raid 0+1
Date: Tue, 29 Oct 2002 09:42:53 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021029154253.GB21099@smeagol>
References: <200210291229.g9TCTcO05488@gg.cyberlab.de> <20021029131453.GB24171@unthought.net> <200210291527.g9TFRl018162@gg.cyberlab.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210291527.g9TFRl018162@gg.cyberlab.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 29, 2002 at 04:27:32PM +0100, Antonello Piemonte wrote:
> for a start I have set my "baseline" measurement: using a 10000 rpm IBM 
> Ultrastar with Adaptec 29160 Ultra160 SCSI adapter
> with 512Mb RAM and PIII-800 I can create 1000 4kb files
> in one directory (this case is what is going to happen in the real
> application) in abou 8secs using this:
> --
> #!/bin/sh
> 
> i=1
> while [ $i -le 1000 ]
> do
>         echo $i
>         dd if=/dev/zero of=file_$i bs=1k count=4
>         i=`expr $i + 1`
> done
> exit 0
> --
> 
> $ time sh write.sh
> ...
>  real    0m8.388s
> user    0m4.037s
> sys     0m3.834s
> 
> writing 10.000 files gives instead
> $ time sh write.sh
> real    1m46.499s
> user    0m40.096s
> sys     1m0.400s
> 
> so a 10-folds increase of number of files gives about
> a 12-fold increase in "real" time ... 
> I will play next with journaling mode (using data=ordered now)
> and post outcome here: thanks for your comments so far !
> antonello

Get rid of while loop in favor of the for loop, your spending alot of
time with the shell!  (It's bad enough this test involves spawning
10,000 copies of dd!).  Also don't do an echo, and pipe dd's output to
dev/null.  You'll increase your numbers -alot- this way.  (Especially
if you are in a fb-console or xterm, I/O to the screen costs -alot-
then).

-Gryn (Adam Luter)
