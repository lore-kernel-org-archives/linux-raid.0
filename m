From: Jason Tinker <jsntinker@gmail.com>
Subject: Re: Incompatibility of internal bitmap with ext4 barriers?
Date: Tue, 17 May 2011 22:43:48 +0400
Message-ID: <BANLkTikvZZYy9fm_sA8oAmkqim1tkbaC_A@mail.gmail.com>
References: <BANLkTin9h+feRNWg1pWFq1t6dmBpn9keKw@mail.gmail.com>
	<20110517191746.556b10fa@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110517191746.556b10fa@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/5/17 Roman Mamedov <rm@romanrm.ru>:
> On Tue, 17 May 2011 16:10:07 +0400
> Jason Tinker <jsntinker@gmail.com> wrote:
>
> The same combination works perfectly for me on 2.6.38.

Do you have RAID5 over RAID0's or an ordinary RAID5? On my box
ordinary RAID5 works perfectly too.

>
> How about a newer kernel, maybe?

This is out of the question, unfortunately. Compiling my own kernel on
top of RHEL would kind of defeat the purpose of having safe low
maintenance distro. And both stable Debian and Ubuntu LTS have the
same kernel.

If your configuration is also RAID5 over RAID0 and it works fine on
2.6.38 then I'll just wait for next ubuntu lts...
