From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH 000 of 3] MD Acceleration and the ADMA interface:
 Introduction
Date: Fri, 03 Feb 2006 13:58:00 -0500
Message-ID: <43E3A7B8.2050607@pobox.com>
References: <1138931168.6620.8.camel@dwillia2-linux.ch.intel.com> <43E39F2B.5080408@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422668AbWBCS6M@vger.kernel.org>
In-Reply-To: <43E39F2B.5080408@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Pierre Ossman wrote:
> Dan Williams wrote:
> 
>>The ADMA (Asynchronous / Application Specific DMA) interface is proposed
>>as a cross platform mechanism for supporting system CPU offload engines.
>>The goal is to provide a unified asynchronous interface to support
>>memory copies, block xor, block pattern setting, block compare, CRC
>>calculation, cryptography etc.  The ADMA interface should support a PIO
>>fallback mode allowing a given ADMA engine implementation to use the
>>system CPU for operations without a hardware accelerated backend.  In
>>other words a client coded to the ADMA interface transparently receives
>>hardware acceleration for its operations depending on the features of
>>the underlying platform.
>>
> 
> 
> I'm wondering, how common is this ADMA acronym? I've been writing a MMC

In ATA land, ADMA is a hardware ATA controller interface, similar to 
AHCI.  We even have a pdc_adma (Pacific Digital ADMA) driver in the 
tree, and NVIDIA uses a variant of the ADMA interface in their SATA 
controllers.

	Jeff
