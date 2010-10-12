From: Simon S <simon@sehier.fr>
Subject: reboot before reshape from raid 5 to raid 6 (was in state
	resync=DELAYED). Doesn't assemble anymore.
Date: Tue, 12 Oct 2010 16:27:53 +0200
Message-ID: <20101012142752.GA16007@leontine.pompomgali.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I had a config with 5 disks and 3 raid 5 arrays:

md2 : system root
md3 : swap
md4 : data

I added a 6th disk with the intention of growing my raid5 into raid6.

The step I used were :

# mdadm /dev/mdX -a  /dev/newdiskX
# mdadm -G --level 6 -n 6 /dev/mdX --backup-file /mdXbackup
 (yes, with backup file on root partition md2...)

The md3 array reshaped without any problem.
md2 seemed to reshape well until it reaches 50.4%, then the rebuild speed stalled at 14Kb/s.
md4 was still in the state "resync=DELAYED" then.

As the rebuild process seemed hung, I restart the machine ... bad idea.

Now mdadm refuses to assemble md2 and md4, and displays this message :

  mdadm: Failed to restore critical section for reshape, sorry.
    Possibly you needed to specify the --backup-file

md2 is my linux installation, not very bad if I lose this one.

md4 however contains valuable data.

While md4 was still in the state resync=DELAYED before the shutdown, I expect
it should not has been (to much) modified and can be recovered.

Any idea on how I could safely do it ?

Should I give a try to the hack "Get 'Grow_restart' to always return 0."
mentionned by Neil Brown on 22 april 2010 in this mailing list ?


Thank for any advices,

Cheers,

-- 
Simon S
