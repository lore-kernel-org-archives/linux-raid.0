From: Neil Brown <neilb@suse.de>
Subject: Re: problems with raid6, mdadm: RUN_ARRAY failed
Date: Mon, 5 Jun 2006 09:22:18 +1000
Message-ID: <17539.27434.353344.175098@cse.unsw.edu.au>
References: <20060602212212.GA14530@max.zg.iskon.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kresimir Kukulj on Friday June 2
Sender: linux-raid-owner@vger.kernel.org
To: Kresimir Kukulj <madmax@iskon.hr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 2, madmax@iskon.hr wrote:
> I have some old controler Mylex Acceleraid 170LP with 6 SCSI 36GB disks on
> it. Running hardware raid5 resulted with very poor performance (7Mb/sec in
> sequential writing, with horrid iowait).
> 
> So I configured it to export 6 logical disks and tried creating raid6 and see
> if I can get better results. Trying to create an array with a missing component
> results in:
> 
> ~/mdadm-2.5/mdadm -C /dev/md3 -l6 -n6 /dev/rd/c0d0p3  /dev/rd/c0d2p3 /dev/rd/c0d3p3 /dev/rd/c0d4p3 /dev/rd/c0d5p3 missing
> mdadm: RUN_ARRAY failed: Input/output error

There should have been some messages in the kernel log when this
happened.  Can you report them too?

Thanks,
NeilBrown
