From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 13:14:58 +0400
Message-ID: <41DBB012.5040308@wasp.net.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au> <qukra2-s1j.ln1@news.it.uc3m.es> <41DB7EB7.4090404@wasp.net.au> <4umsa2-c9q.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4umsa2-c9q.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Brad Campbell <brad@wasp.net.au> wrote:
> 
>>If a bit has flipped on a parity stripe and thus the parity is inconsistent. When I pop out a disk 
>>and put it back in, the array is going to be written from parity data that is not quite right. (The 
>>problem I believe you were talking about where you have two identical disks and one is inconsistent, 
>>which one do you read from? is similar). And thus the reconstructed array is going to have different 
>>contents to the array before I failed the disk.
>>
>>Therefore it should show the error. No?
> 
> 
> It will not detect it as an error, if that is what you mean.

Now here we have a difference of opinion.

I'm detecting errors using md5sums and fsck.

If the drive checks out clean 1 minute, but has a bit error in a parity stripe and I remove/re-add a 
drive the array is going to rebuild that disk from the remaning data and parity. Therefore the data 
on that drive is going to differ compared to what it was previously.

Next time I do an fsck or md5sum I'm going to notice that something has changed. I'd call that an error.

Brad
