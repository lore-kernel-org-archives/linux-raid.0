From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 09:44:23 +0400
Message-ID: <41DB7EB7.4090404@wasp.net.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au> <qukra2-s1j.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <qukra2-s1j.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Brad Campbell <brad@wasp.net.au> wrote:
> 
>>I do occasionally remove/re-add a drive to each array, which causes a full resync of the array and 
>>should show up any parity inconsistency by a faulty fsck or md5sum. It has not as yet.
> 
> 
> No - it should not show it. 
> 


If a bit has flipped on a parity stripe and thus the parity is inconsistent. When I pop out a disk 
and put it back in, the array is going to be written from parity data that is not quite right. (The 
problem I believe you were talking about where you have two identical disks and one is inconsistent, 
which one do you read from? is similar). And thus the reconstructed array is going to have different 
contents to the array before I failed the disk.

Therefore it should show the error. No?

Brad
