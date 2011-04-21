From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: debian software raid1
Date: Thu, 21 Apr 2011 10:50:28 -0400
Message-ID: <4DB04434.4080505@cdf.toronto.edu>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu> <20110420085148.12ac0002@notabene.brown> <4DAE29EA.4040306@gmail.com> <4DAEF2F1.8080204@cdf.toronto.edu> <20110421061545.GA15220@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110421061545.GA15220@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Luca,

On 04/21/11 02:15, Luca Berra wrote:
> If someone here still believes that drives from different vendors with
> the same nominal size have different real size please read:
> http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1192

I don't think my point is invalid. If you wanted to mix SSDs and spindle 
HDDs (for, say, write-mostly "backup" of the SSDs), quite likely your 
drives will be of different sizes, as the SSDs frequently come in sizes 
that are power of two's unlike the spindle drives. You could start of 
with just one type of drive, and only then come up with the idea of 
mixing types, etc. Probably not the best example, but one nonetheless.

There are other benefits to using a partition instead of the whole 
device. For example, you could use a GPT label, which allows you to 
label individual partitions. In an earlier post, I sent out a gpt_id 
script and UDEV rules which insert /dev/disk/by-label/ links for you to 
GPT-labeled partitions. We use it at the CS department of U of Toronto 
to keep track of the physical location of disks (within iscsi target hosts).

I think that if you are not interested in the 2nd point here, you could 
simply use the --size option to mdadm to use less than the total 
capacity of the drives, but apparently it doesn't work for all RAID 
levels (RAID 10 is not listed in Debian Lenny's man-page). Somebody 
correct me if I am wrong about this.

Cheers!
Iordan

