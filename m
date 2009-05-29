From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Need information regarding RAID 6 Async APIs for kernel version
  2.6.27
Date: Fri, 29 May 2009 12:13:50 -0700
Message-ID: <4A2033EE.4040302@intel.com>
References: <264829.64332.qm@web94806.mail.in2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <264829.64332.qm@web94806.mail.in2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: satha kottidi <satha_koti@yahoo.co.in>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

satha kottidi wrote:
> Hi all,
> 
> Dan thanks for your recommendations, I followed it, got the present 
> running branch and working on it.
> 
> I have one more rquest, presently I want to run the Async_tx APIs 
> (RAID6) in kernel 2.6.27, Is any suggestions for further process.
> 
> Is the only way I have to extract the changes in the branch and applied 
> to my kernel, or any other ways.
> 
> Can you please help me in this regard also.

Backporting is a black art, and is rarely straightforward.  In a perfect 
world you could use Stacked GIT to rebase all the relevant changes onto 
a 2.6.27 base with a script like:

git log --reverse v2.6.27..async_tx/raid6 --no-merges\
--pretty=format:"%H" drivers/md/md.c drivers/md/raid5.c drivers/dma/ \
crypto/async_tx/ > commits

git checkout -b 2.6.27-raid6 v2.6.27
stg init
cat commits | while read commit;
do
	stg pick $commit
done

...but there is a high likelihood to encounter merge conflicts and other 
  cross-tree dependencies especially when trying to backport across ~3 
kernel versions.

Good luck,
Dan
