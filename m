From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: Re: does chunksize matter in raid-1?
Date: Sat, 06 Aug 2005 12:47:35 -0500
Message-ID: <42F4F7B7.7080009@dynaconnections.com>
References: <e03b90ae05080521077404ad09@mail.gmail.com> <42F4B0C1.1080306@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42F4B0C1.1080306@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: jeff@jab.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:

> No, chunk size does not matter for raid1. In fact, some/most? kernels 
> will print a message to that effect if you specify a chunk size for a 
> raid1 array.

Yet if you use raidtools and /etc/raidtab you must specify chunksize it 
to create a RAID1....

In other words, stick to mdadm.

-ryan
