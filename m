From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: implications of partitioning and raid
Date: Fri, 06 Jan 2012 05:34:09 -0600
Message-ID: <4F06DC31.20008@hardwarefreak.com>
References: <1325778034.4777.44.camel@hermosa.lnx.copansys.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1325778034.4777.44.camel@hermosa.lnx.copansys.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter W. Morreale" <morreale@sgi.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/5/2012 9:40 AM, Peter W. Morreale wrote:

> Assume a portion of disk 1 goes 'bad' (localized within one of those
> partitions), is noticed by md and a rebuild is warranted.

How often does only a "portion" of a disk go bad these days?  Typically
this would mean unrecoverable read/write errors for a set of LBA
sectors.  Physically, with the majority of today's disks, these
perceived sector defects are actually the result of head actuator and/or
spindle bearing wear beyond tolerances, not magnetic defects in the
platters.

Thus, any such defective "portions" are typically doing to "grow" fairly
rapidly.  Which means, in your scenario, both arrays are going to need
new spare partitions and a rebuild in short order, as an entire disk is
failing, not just a portion thereof.

RAID - Redundant Array of Inexpensive Disks
RAIP - Redundant Array of Inexpensive Partitions

Aside from sounding like a sexual crime, there are many other obvious
reasons why the latter has never been coined nor considered a storage
standard by anyone.

There are valid reasons for partition based arrays, such as booting from
disks with wonky offset requirements (e.g. advanced format drives).
IMHO the scenario you've presented here is not a valid case for
partition based arrays.

-- 
Stan
