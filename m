From: "Derek Listmail Acct" <listmail@oversimplified.com>
Subject: RE: Scrub?
Date: Fri, 6 Aug 2004 13:07:16 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1951.216.222.31.66.1091819236.squirrel@mail.oversimplified.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153121@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153121@otce2k03.adaptec.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> dd if=/dev/zero of=/dev/md0 bs=200b
>

This will fill the array with zeros, which isn't what I want to do.  I'm
trying to verify the parity data for my raid 5 array is correct.  I feel
one of my drives may be failing, and want to make sure the array is
consistent.
