From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC][PATCH 000 of 3] MD Acceleration and the ADMA interface:
 Introduction
Date: Fri, 03 Feb 2006 19:21:31 +0100
Message-ID: <43E39F2B.5080408@drzeus.cx>
References: <1138931168.6620.8.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1138931168.6620.8.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Dan Williams wrote:
> 
> The ADMA (Asynchronous / Application Specific DMA) interface is proposed
> as a cross platform mechanism for supporting system CPU offload engines.
> The goal is to provide a unified asynchronous interface to support
> memory copies, block xor, block pattern setting, block compare, CRC
> calculation, cryptography etc.  The ADMA interface should support a PIO
> fallback mode allowing a given ADMA engine implementation to use the
> system CPU for operations without a hardware accelerated backend.  In
> other words a client coded to the ADMA interface transparently receives
> hardware acceleration for its operations depending on the features of
> the underlying platform.
> 

I'm wondering, how common is this ADMA acronym? I've been writing a MMC
driver for some hardware where specifications aren't available. I have
found one document which list an "ADMA system address" register, with a
width of 64 bits. What are the odds of this being something that
conforms to said interface?

Rgds
Pierre

