From: Luca Berra <bluca@comedia.it>
Subject: Re: debian software raid1
Date: Fri, 22 Apr 2011 07:59:39 +0200
Message-ID: <20110422055939.GA14247@maude.comedia.it>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu> <20110420085148.12ac0002@notabene.brown> <4DAE29EA.4040306@gmail.com> <4DAEF2F1.8080204@cdf.toronto.edu> <20110421061545.GA15220@maude.comedia.it> <4DB04434.4080505@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DB04434.4080505@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 21, 2011 at 10:50:28AM -0400, Iordan Iordanov wrote:
> Hi Luca,
>
> On 04/21/11 02:15, Luca Berra wrote:
>> If someone here still believes that drives from different vendors with
>> the same nominal size have different real size please read:
>> http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1192
>
> I don't think my point is invalid. If you wanted to mix SSDs and spindle 
> HDDs (for, say, write-mostly "backup" of the SSDs), quite likely your 
> drives will be of different sizes, as the SSDs frequently come in sizes 
> that are power of two's unlike the spindle drives. You could start of with 
> just one type of drive, and only then come up with the idea of mixing 
> types, etc. Probably not the best example, but one nonetheless.
no, not the best example :D

> There are other benefits to using a partition instead of the whole device. 
there are both benefits and disadvantages, both lists are long enough
without adding non-issues.

> For example, you could use a GPT label, which allows you to label 
> individual partitions. In an earlier post, I sent out a gpt_id script and 
> UDEV rules which insert /dev/disk/by-label/ links for you to GPT-labeled 
> partitions. We use it at the CS department of U of Toronto to keep track of 
> the physical location of disks (within iscsi target hosts).
So, if i understood correctly, you use partitions on something which is
not a real HDD, hope you got the data alignment part correct.

L.
-- 
Luca Berra -- bluca@comedia.it
