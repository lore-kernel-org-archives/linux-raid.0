From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Help resyncing/remounting raid5 array please
Date: Tue, 21 Oct 2003 14:34:25 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F957C31.9B652FEC@SteelEye.com>
References: <000d01c397ff$ca6de440$0600a8c0@Robinton>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ruth Ivimey-Cook wrote:
 
> Is there any way forward?

Yep. You can use mdadm to assemble the array using the two good disks.
You can then hot-add the bad disk and the array should resync the way
you want it to. Check the mdadm man pages and/or google for using mdadm
--assemble to fix an array that can't be started, it's a topic that's
been discussed here many times.

--
Paul
