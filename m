From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Sun, 23 Jul 2006 15:28:30 +0300
Message-ID: <5b170a7d0607230528s734c1dceq48a89ce49f19d71d@mail.gmail.com>
References: <44BD4F2F.2050502@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BD4F2F.2050502@online.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quack@online.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/19/06, Sevrin Robstad <quack@online.no> wrote:
> I tried file -s /dev/md0 also, and with one of the disk as first disk I
> got "ext 3 filedata (needs journal recovery) (errors)" .

Congratulations, you have found your first disk. Does fsck still
complain about the magic number?
