From: Derek Vadala <derek@cynicism.com>
Subject: Re: mdadm -A /dev/md3 fails
Date: Mon, 9 Sep 2002 01:18:52 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0209090115370.11702-100000@jaded.cynicism.com>
References: <20020909075559.GE3806@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020909075559.GE3806@merlins.org>
To: Marc MERLIN <marc_news@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Sep 2002, Marc MERLIN wrote:

> gargamel:/etc/mdadm# mdadm -A  -v /dev/md3
> mdadm: No identity information available for /dev/md3 - cannot assemble.

Try mdadm -Avs /dev/md3

-s or --scan tells mdadm to use the config file.

or

mdadm -Avs to start all the arrays found in /etc/mdadm.conf

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek


