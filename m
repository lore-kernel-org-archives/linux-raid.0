From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Multiple drive failure after stupid mistake. Help needed
Date: Sun, 19 Oct 2014 12:56:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1410191253010.30853@uplift.swm.pp.se>
References: <54438839.9080309@stenborg.me>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54438839.9080309@stenborg.me>
Sender: linux-raid-owner@vger.kernel.org
To: Per-Ola Stenborg <per-ola@stenborg.me>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 19 Oct 2014, Per-Ola Stenborg wrote:

> *** PLEASE advice ***

Please post dmesg output from when you do --assemble --force, and also 
please post your mdadm and kernel versions.

As a first step, compile mdadm from source and use that version, it often 
helps as distributions don't generally ship with the latest mdadm.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
