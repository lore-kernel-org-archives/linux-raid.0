From: Mitchell Laks <mlaks@verizon.net>
Subject: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sat, 12 Mar 2005 23:51:23 -0500
Message-ID: <200503122351.23430.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I have a remote system with a raid1 of a data disk. I got a call from  the 
person using the system that the application that writes to the data disk was 
not working.

system drive is /dev/hda with separte partitions / , /var, /home, /tmp.
data drive is linux software raid1 /dev/md0 with /dev/hdc1,  /dev/hde1. 

I logged in remotely and discovered that the /var partition was full because 
many write errors from /dev/hde1 in /var/log/syslog.

When I looked into cat /proc/mdstat i discovered that /dev/md0 was degraded  
because /dev/hdc1 had failed (there was an f there) and /dev/hde1 was 
carrying the load.

I shut down the applications in background. I emptied out /var/log/syslog. I 
then removed /dev/hdc1 from the array /dev/md0. 

I had another pair of drives on the system that was part of another mirrored 
array /dev/md1 with no useful information stored on them. 

/dev/md1  /dev/hdf1 /dev/hdh1 

I thought ok, let me detach /dev/hdf1 from the  other array /dev/md1  and try 
attach it to /dev/md0 and rebuild the array /dev/md0. That way i would rescue 
the data on the threatening drive /dev/hde1 which is spewing out error 
messages to my /var/log/syslog and threatening to die! 

So stupidly (probably), I did

mdadm /dev/md1  --fail /dev/hdf1 --remove /dev/hdf1

then i did 
mdadm /dev/md0 --add /dev/hdf1

Now when i did 
cat /proc/mdstat I see:

md0 : active raid1 hdf1[2] hde1[0]
      244195904 blocks [2/1] [U_]
        resync=DELAYED

I don't see any rebuilding action going on.

Did I have to do something like fdisk 
to the drive /dev/hdf1 before adding it to the array?? I didnt do anything to 
zero out the data that was on the disk (no data really just whatever was 
created on the disk when i made it part of an ext3 raid /dev/md1.  I had 
fdisked it a while ago as a linux raid type partition...

What do I do to rebuild the raid?
Thanks millions for your help!!
Mitchell
