From: Luca Berra <bluca@comedia.it>
Subject: Re: Possible failures in raid5?
Date: Thu, 30 Dec 2004 07:53:45 +0100
Message-ID: <20041230065345.GA9851@percy.comedia.it>
References: <41D1EB01.1040204@advocap.org> <200412290335.iBT3Zc913406@www.watkins-home.com> <20041229213841.GC32160@percy.comedia.it> <41D34066.2080501@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41D34066.2080501@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 30, 2004 at 03:40:22AM +0400, Brad Campbell wrote:
>Luca Berra wrote:
>>On Tue, Dec 28, 2004 at 10:35:33PM -0500, Guy wrote:
>>
>>>For testing the disk(s) status, look at smartd.
>>>My disks are too old, but newer disks should support this.
>>
>>except that libata does not support S.M.A.R.T.
>
>There is an experimental patch in the libata-dev tree that appears (and I 
>mean it works for me) to support SMART reliably on a UP kernel. There is a 
>known issue with SMP kernels ATM. I have been using it every 20 minutes on 
>a reasonably loaded server with 13 SATA and 1 ATA disks now for what must 
>be several months with no issues. (It has helped detect a pending disk 
>failure quite nicely)/
>
>I guess it will stay experimental until someone with an SMP machine can 
>assist Andy in debugging the SCSI passthough code (It's not SMART specific 
>at this stage).

thanks for the info, i will check it out (is there a snapshot of the
libata-dev for non bk users? /pub/linux/kernel/people/jgarzik/libata on
kernel.org seems to be a bit behind)
Unfortunately i don't own a SMP machine with sata drives.
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
