From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 18:35:46 +0100
Message-ID: <4B856372.6000900@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <20100224170951.GC11039@cthulhu.home.robinhill.me.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224170951.GC11039@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 18:09, schrieb Robin Hill:

> If these are the only disks with up-to-date data, and sda4 is still
> failing, I can only suggest stopping the array and using dd/dd_rescue to
> copy sda4 onto a working disk.  You should then be able to reassemble
> the array with sdb4 and the new disk, then add in a hot spare to
> recover.

Currently sdd isn't in use at all.

So I could


mdadm --stop /dev/md4

ddrescue /dev/sda4 /dev/sdd4

mdadm --assemble --force /dev/md4 /dev/sdb4 /dev/sdd4

??

Sorry for my explicit questions, I am rather stressed here ...

S
