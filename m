From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Possible failures in raid5?
Date: Thu, 30 Dec 2004 03:40:22 +0400
Message-ID: <41D34066.2080501@wasp.net.au>
References: <41D1EB01.1040204@advocap.org> <200412290335.iBT3Zc913406@www.watkins-home.com> <20041229213841.GC32160@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041229213841.GC32160@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Tue, Dec 28, 2004 at 10:35:33PM -0500, Guy wrote:
> 
>> For testing the disk(s) status, look at smartd.
>> My disks are too old, but newer disks should support this.
> 
> except that libata does not support S.M.A.R.T.

There is an experimental patch in the libata-dev tree that appears (and I mean it works for me) to 
support SMART reliably on a UP kernel. There is a known issue with SMP kernels ATM. I have been 
using it every 20 minutes on a reasonably loaded server with 13 SATA and 1 ATA disks now for what 
must be several months with no issues. (It has helped detect a pending disk failure quite nicely)/

I guess it will stay experimental until someone with an SMP machine can assist Andy in debugging the 
SCSI passthough code (It's not SMART specific at this stage).

-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
