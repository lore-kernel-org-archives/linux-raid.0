From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Mon, 14 Mar 2005 02:43:24 -0500
Message-ID: <200503140243.25308.mlaks@verizon.net>
References: <200503122351.23430.mlaks@verizon.net>
 <423460EE.9070602@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-8-i
Content-Transfer-Encoding: 7bit
In-reply-to: <423460EE.9070602@dgreaves.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 13 March 2005 10:49 am, David Greave wrote: Many Helpful remarks:
> 
David I am grateful that you were there for me.
I went to the site. I connected a monitor to the headless machine. I saw the 
screen flooded with write errors to the spare drive in the original raid1.

The terminals were flooded on tty1-6. I had to log in remotely  on network. I 
tried to shutdown -h now. I tried "init 1" as root. No go. I had to hard 
power down the machine. Debian boot dropped me into single user mode on 
bootup and I took /dev/md0 out of the /etc/fstab to get the machine to boot 
past the fsck on boot.

I looked through /var/log/messages.0. I found that on last wednesday at 10am 
drive /dev/hda1 failed. The paired drive (it actually was /dev/hdg1)  in the 
raid1 began to issue bad kernel messages immediately. These filled the /var 
directory to 100% and seemed to have caused all the bad  behavior we saw.

I had noticed that /var was full initially and made room by cutting out much 
of /var/log/messages.

I likely could not successfully run "shutdown -h now" because the /var 
partition likely needed some kind of fsck or something to deal with having 
been filled and the many many processes that had been writing to it were very 
"angry" and in a "messy state". They needed a powerdown. (Very m$ftlike).

I am not sure I mentioned here, (but  I discussed on another mailing list :)), 
that my main application on the server is a database backed application 
running off of a postgresql backend. 

Postgresql was also put into a weird state by this incident - not because 
there was anything wrong with it. Just because filling /var partition caused 
multiple effects, cause postgresql databases live in /var/lib/postgres. I 
could not run pg_ctl stop or pg_ctl stop -m fast. Only pg_ctl stop -m 
immediate. Luckily I was able to rescue the database.

My assessment (correct me if I am wrong) is that I have to rethink my 
architecture. As I continue to work with software raid, I likely will have to 
move the postgresql database to a separate partition, so I will not have 
mixing of points of failure.  

I took out the 2 drives /dev/hda1 and /dev/hdg1 from the machine. I restored 
my systems from the most recent backup, with only a few days worth of suspect 
data (wed/thur/friday ...). I replaced with new hard drives. Its good to have 
duplicate servers and raids. Both are neccesary I see.

I will play with /dev/hdg1 a little on a different machine to see what it 
behaves like. I suspect with all those errors it is really dead too.

I just had bad luck. A double disk failure.

Thank you David again!

Mitchell
