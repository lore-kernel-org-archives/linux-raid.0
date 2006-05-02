From: Gil <gil@fooplanet.com>
Subject: Re: RAID1: can't remove (or set-faulty) a disk during resync with
 mdadm
Date: Tue, 02 May 2006 12:44:41 -0700
Message-ID: <4457B6A9.9030608@fooplanet.com>
References: <4457B4CD.7030709@dm.cobite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4457B4CD.7030709@dm.cobite.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Mansfield <centos@dm.cobite.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Mansfield wrote:
> When I run mdadm --manage -f /dev/md1 /dev/hdb2 it only causes the
> resync to start again from the beginning, it doesn't actually mark it bad.

For grins, does mdadm --manage /dev/md1 -f /dev/hdb2 behave
differently?  Or just mdadm /dev/md1 -f /dev/hdb2?

I ran basically the last one on a CentOS 4.3 box not more than a
week ago and it was fine.

--Gil
