From: Phil Turmel <philip@turmel.org>
Subject: Re: Not getting anything from mdadm --examine for raid1 array
Date: Sat, 26 Jan 2013 18:26:46 -0500
Message-ID: <51046636.1010601@turmel.org>
References: <5102E7C5.6040900@stpaulshk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5102E7C5.6040900@stpaulshk.org>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <techlead@stpaulshk.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/25/2013 03:15 PM, William Colls wrote:

[trim /]

> mdadm --examine --scan /dev/md0 returns nothing.

"--detail" is for array devices like /dev/md0

"--examine" is for array members like /dev/sdb

HTH,

Phil

