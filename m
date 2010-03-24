From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Questions regarding startup of imsm container
Date: Tue, 23 Mar 2010 22:54:58 -0700
Message-ID: <4BA9A932.3020305@intel.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com> 	<e9c3a7c21003231401p55d4e392u22b062aaf464b1da@mail.gmail.com> 	<7db987b31003231441j56733b15wd111c4aa22e9eccc@mail.gmail.com> 	<4BA93DBB.6000503@intel.com> <7db987b31003231625obb9f3c5r986988defdf68a08@mail.gmail.com> <7db987b31003231723tac48bf5ocb3723522dc54417@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003231723tac48bf5ocb3723522dc54417@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Terbush <randy@terbush.org>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Randy Terbush wrote:
> Update on progress....
> 
> I have managed to hack together a dracut created initramfs that has me
> able to boot and has resolved all boot issues. Will let this thing
> have a few hours of resyncing and see if external bitmap comes back
> and how it handles the reboot.
> 

I expect it will still come back up and resync again because I doubt the 
initscripts and killall5 implementation in Gentoo comprehend the 
coordination that needs to happen with mdadm/mdmon at system shutdown.

The two necessary pieces for external metadata support in the system 
halt script are:
1/ killall5 needs to omit mdmon from the process shutdown step
2/ A call to mdadm --wait-clean --scan is needed to ensure that mdmon 
has had a chance to mark the array clean before reboot/shutdown.

Note that step 2 requires that mdadm can find the mdmon communication 
socket which lives (by default) in /var/run/mdadm.

--
Dan

