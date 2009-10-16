From: mark delfman <markdelfman@googlemail.com>
Subject: MD write performance issue
Date: Fri, 16 Oct 2009 09:45:37 +0100
Message-ID: <66781b10910160145r59f3ea0cqc8632dbc3d92f833@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

After further work we are sure that there is a significant write
performance issue with either the Kernel+MD or with
Me_Being_Stupid+MD.   I would be happy to find out it is the latter,
but given the possibility it may be Kernel+MD I thought I should raise
this again under a new thread with below info.

On previous threads I stated that on later kernels XFS > MD dropped up
to 50% performance... I now have tested several filesystems (it is not
XFS related) and several Kernel=92s (it is related to Kernel)

Below is the basic summary of the various Kernel write performance
results... all on the same hardware and Open SUSE foundation.
1.1GBsec is the max this particular hardware will provide and in a
single stream XFS would normally match this.  You can see that
depending on Kernel the write performance can drop to 50%.....

(note: we have tried this with a hardware raid and there is no
performance drop between direct or via a FS.)

I really am stuck as to where to go from here, I would like to use .30
kernels and I am sure that there is a solution to this but do not have
enough linux experience to think of any further steps, so very much
appreciate any advice.



Linux linux-tlfp 2.6.27.7-vanilla #1 SMP Thu Oct 15 19:52:43 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1 GB/s
XFS: 1.1 GB/s
(tests with simple DD=92s, but I have also  tried FIO etc)

2.6.30.8

RAW: 1.1 GB/s
XFS: 900 MB/s

Linux linux-tlfp 2.6.28.4-vanilla #1 SMP Thu Oct 15 21:36:51 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1 GB/s
XFS: 1.1 GB/s



Linux linux-tlfp 2.6.31.4-vanilla #1 SMP Thu Oct 15 22:11:16 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW 1,1 GB/s
XFS: 920 MB/s



Linux linux-tlfp 2.6.28.10-vanilla #1 SMP Thu Oct 15 22:44:26 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1
XFS: 684 MB/s



Linux linux-tlfp 2.6.27.37-vanilla #1 SMP Thu Oct 15 23:32:53 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1 GB/s
XFS 520 MB/s


Linux linux-tlfp 2.6.27.20-vanilla #1 SMP Thu Oct 15 23:59:32 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAw 1.1 GB/s
XFS: 487 MB/s



Linux linux-tlfp 2.6.27.14-vanilla #1 SMP Fri Oct 16 00:56:25 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1
XFS 1.1
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
