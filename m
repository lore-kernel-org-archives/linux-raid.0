From: "Hibbard T. Smith, JR" <smitty@essnjay.com>
Subject: Problems booting from an Adaptec 2010s in 2.6.26
Date: Fri, 10 Oct 2008 08:52:57 -0400
Message-ID: <383a01c92ad7$1e9c8840$6464a8c0@essnj2a>
Reply-To: <smitty@essnjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I posted this in software at linuxquestions and got a reply that I should
join this mailing list and ask here. I realize that this isn't strictly
speaking a RAID issue or even a kernel issue.  However, I can't figure out a
better mailing list  to use.  So, if I'm in the wrong place, please let me
know and I'll go to the "right place".  It would really be great to get this
fixed officially.

 

Quote:
I finally got Fedora 9 running on this system. It has a RAID 1 pair running
on an Adaptec 2010 ZCR as the system partitions. It's the 2nd disk subsystem
with a 3ware 9500s based SATA RAID 50 as the first disk subsystem. The
system boots from and is rooted on the Adaptec based RAID.

The install went fine. This was a big improvement on previous releases (6
and up). So, I had been continuing to muddle along with FC5. After the
install, the system refused to boot. So, I booted into rescue mode from the
DVD and went to work trying to figure out what was wrong.

After a lot of searching and trouble shooting, I finally figured out that
the initrd built during the install did not contain the i2o_block driver.
The i2o subsystem requires an i2o_core and i2o_block driver to access block
devices on the Adaptec. While booted in rescue mode, I rebuilt the initrd
adding the i2o_block driver and modifying init and modules.dep to load it. I
did this by changing the init to load i20_block and making i2o_block depend
on i2o_core in the modules.dep. The system then boots and runs fine.
However, every time a kernel update occurs, I have to rebuild the new initrd
in order to be able to boot the new kernel. 

Either mkinitrd or one of the underlying module manipulation programs thinks
(incorrectly) that i2o_core is all that's required to run block devices on
the Adaptec. I've looked at the various files and programs that mkinitrd
uses to get this done, and I'm not sure where the fix has to occur. Does
anyone have any good ideas? It looks to me like a simple approach would be
to change the lookup in modules.alias (looked up by pci id) to load
i2o_block instead of i2o_core and make the i2o_block depend on i2o_core in
modules.dep. I'm going to give that a shot, but I was hoping someone would
have a real fix. It would be really nice if this could get into the future
distributions as I've been fighting with various forms of this issue since
FC5. I'm sure it's probably been an issue for several others also. By
searching around the Internet, I can see several cries for help with this,
but not many solutions.

It seems that the structure of the i2o drivers requiring 2 drivers instead
of just one has messed up the approach taken for building the initrd.

How can I get this into the queue for action and resolution at the official
level? Would bugzilla at Redhat be appropriate? It's not really a Fedora
specific issue, and it's probably not a kernel issue. 
End Quote
 

I have developed a fix (hack?) for mkinitrd.  If this is the correct mailing
list, I'll post a patch  here.  I'm not sure that mkinitrd is the correct
place to resolve this, but the structure of the i2o driver(s) doesn't seem
to lend itself to a fix elsewhere.  



Smitty

Hibbard T. Smith, JR

smitty@essnjay.com

