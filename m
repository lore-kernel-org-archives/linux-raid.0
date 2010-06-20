From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID5: two disks dropping out
Date: Sun, 20 Jun 2010 17:42:35 +0200
Message-ID: <4C1E36EB.1070508@xunil.at>
References: <4C1926B5.3060106@xunil.at> <4C1BA355.9080003@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1BA355.9080003@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 18.06.2010 18:48, schrieb Stefan G. Weichinger:

> Now I would like to reshape the RAID5 to RAID6 ... shrinking the LVM-PV
> seems to be the much trickier way than moving data aside, recreate a new
> RAID6 and restore data?

Asked in another way:

What is the recommended and safest way to move from a 6-disk RAID5 to a
6-disk RAID6 when the whole md-device is the only PV in a LVM-VG?

Stefan
