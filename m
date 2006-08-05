From: "=?ISO-8859-1?Q?Martin_Schr=F6der?=" <martin@oneiros.de>
Subject: Re: raid5/lvm setup questions
Date: Sat, 5 Aug 2006 23:02:19 +0200
Message-ID: <68c491a60608051402i7eda8a26t304fa86a0b8a81e1@mail.gmail.com>
References: <20060805165358.GA29177@cm.nu> <44D4D5F9.9080201@dgreaves.com>
	 <20060805175908.GA31024@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060805175908.GA31024@cm.nu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/8/5, Shane <shane@cm.nu>:
> Well, the reason I was looking at LVM is because since this
> is a fairly big array, I didn't want to lose a bunch of
> space with ext3 inodes.  For example, the PostGreSQL

Then forget about ext{2|3} and use xfs or reiserfs. ext3 is limited to
4TB anyway.

Best
   Martin
