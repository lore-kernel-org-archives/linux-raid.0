From: Julie Ashworth <ashworth@berkeley.edu>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Mon, 24 Feb 2014 16:16:53 -0800
Message-ID: <20140225001653.GA31372@ssh2.neuro.berkeley.edu>
References: <20131217065028.GC20941@nx5.priv>
 <20131217165348.GA5070@localhost.localdomain>
 <52B09027.5090605@turmel.org>
 <20131217192637.GB5070@localhost.localdomain>
 <52B0A956.7030501@turmel.org>
 <20131218034556.GA9457@localhost.localdomain>
 <52B19045.5010102@turmel.org>
 <20140121063808.GA27520@ssh2.neuro.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140121063808.GA27520@ssh2.neuro.berkeley.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Phil!
I only had one glitch - my version of lvm2 (lvm2-2.02.74-5.el5_6.1) created mirrored extents on the same physical device. I reverted to linear LVs, upgraded lvm2, and it worked perfectly.
Words can't express my gratitude - you saved me so much time and stress. Do you like pizza? Dominos? Pizza Hut? ;)
best,
Julie
