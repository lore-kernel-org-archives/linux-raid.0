From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: Invalid superblock on drives in array
Date: Thu, 25 Dec 2003 11:58:48 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1072371527.3636.1.camel@binkley>
References: <Pine.GSO.4.44L.0312251708280.28023-100000@legolas.mdh.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.44L.0312251708280.28023-100000@legolas.mdh.se>
To: Peter Jonsson <dal01pjn@mds.mdh.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2003-12-25 at 11:58, Peter Jonsson wrote:
> Hi!
> 
> I'm running a RAID-5 setup using six Seagate ST19171W SUN9.0G drives off a
> Sun Multipack connected to an Adaptec 2940UW. I used to have the multipack
> connected to a Sparcstation 5 but I moved it yesterday. Everything was
> running fine until I rebooted the machine.
> 


if this was running on a sparc then you might want to look at:

mdadm --update=sparc2.2

look at the mdadm man page:

              The  sparc2.2 option will  adjust the superblock of
              an array what was created on a Sparc  machine  run-
              ning  a  patched 2.2 Linux kernel.  This kernel got
              the alignment of part of the superblock wrong.  You
              can use the --examine --sparc2.2 option to mdadm to
              see what effect this would have.




> I'm not really sure what happend. I think what I did was to reboot the
> machine to use a new kernel. This machine was a clean RH9 installation and
> I applied a 'yum upgrade' to it after installing yum. I have since tried
> to use the array with the older kernel but that don't work either.
> 

Oh and I'm also the yum author and I assure you, yum doesn't touch
ANYTHING related to raid arrays, it just updates packages :)

-sv


