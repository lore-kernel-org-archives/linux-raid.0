From: David Greaves <david@dgreaves.com>
Subject: Re: Confused about UUID mounting and mirrors
Date: Mon, 16 Jun 2008 22:38:35 +0100
Message-ID: <4856DD5B.9050303@dgreaves.com>
References: <4856A8C6.3030609@kmaclub.com> <4856CFE1.1020105@ziu.info> <4856DB4C.20905@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4856DB4C.20905@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@kmaclub.com wrote:
> UUID=8e651838-38c1-4783-8bde-4174ec484d52 /     ext3    defaults  1 1
> UUID=aaeca70c-f0fe-470c-b631-87248648d275 /export xfs defaults,nobarrier
> 1 2
> UUID=6e22c5b0-2874-4826-a871-ed733f8da643 swap swap    defaults   0 0
> UUID=323cd094-4cbe-4c3b-9096-366c05465e7c /export/services xfs defaults 1 2
> 
> so it is referring to the UUID of the filesystem and not necessarily the
> device.  Some are single partitions, some md devices, and some sit on
> top of LVM.

What does :
  mdadm --detail /dev/md0 | grep UUID
show?

I think it will give you the UUID of the md device, not the fs on the md device
(which as you have seen is also the UUID of the fs visible on the md components)

David
