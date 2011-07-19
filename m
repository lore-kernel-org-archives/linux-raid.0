From: Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: data corruption after rebuild
Date: Tue, 19 Jul 2011 18:35:26 +0200
Message-ID: <4879002.CX4iSyfhxZ@bloomfield>
References: <2073005.NH8LALaxuD@bloomfield> <20110719211240.2578bba6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719211240.2578bba6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 19 of July 2011 21:12:40 Roman Mamedov wrote:
> > I do monthly scans, so the redundancy syndromes should have been
> > up-to-date, the array is made of 8 disks, the setup is ext4 on lvm on
> > mdraid
> 
> Did you notice any nonzero mismatch_cnt during those scans?

oh crap, the rebuild finished with

Jul 19 09:41:24 Bloomfield mdadm[3996]: RebuildFinished event detected on md device /dev/md0, component device  mismatches found: 3184

this is really bad i presume? 
