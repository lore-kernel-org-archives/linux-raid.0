From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 07:53:40 -0500
Message-ID: <5113A3D4.6000605@turmel.org>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113A2D6.20104@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/07/2013 07:49 AM, Adam Goryachev wrote:
> Well, if I can re-trim daily, and have enough clean space to work for 2
> days, then I should never hit this problem.... Assuming it loses *that
> much* performance....

You keep saying this, but you are only going to be trimming the
unpartitioned space.  That won't help you after the first trim.

Phil

