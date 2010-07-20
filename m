From: Konstantin Svist <fry.kun@gmail.com>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 23:29:26 -0700
Message-ID: <4C454246.3030703@gmail.com>
References: <4C439D19.4070906@gmail.com> <4C44939A.1060200@gmail.com> <4C4525E8.2010702@relevad.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C4525E8.2010702@relevad.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  On 07/19/2010 09:28 PM, Konstantin Svist wrote:
> Can someone confirm that this command should work to revert the size?
> mdadm --grow -z 879100608 --backup-file=/root/grow_md0_size_revert.bak 
> /dev/md0

Finally sat down and thought about it - created a temporary raid using 
/dev/ram## and copied some files to it, did the same operations on it.
Amazingly, all the files came back. Will see if the real thing works too
