From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 17:38:57 +0100
Message-ID: <4B855621.5010000@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B85467C.5020008@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 16:32, schrieb Stefan G. Weichinger:


> I report back later with more details ...

sda4 drops out repeatedly ...

Swapped physical sdc already ... adding sdc4 leads to failing md4 again
after starting the rebuild.

I now have md4 on sda4 and sdb4 ... xfs_repaired ... and sync the data
to a plain new xfs-partition on sdc4 ... just to get current data out of
the way.

oh my
