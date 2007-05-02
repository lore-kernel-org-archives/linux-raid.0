From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 00/16] raid acceleration and asynchronous offload api
 for	2.6.22
Date: Wed, 02 May 2007 16:55:03 +1000
Message-ID: <463835C7.3020902@yahoo.com.au>
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2992861AbXEBGzQ@vger.kernel.org>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> I am pleased to release this latest spin of the raid acceleration
> patches for merge consideration.  This release aims to address all
> pending review items including MD bug fixes and async_tx api changes
> from Neil, and concerns on channel management from Chris and others.
> 
> Data integrity tests using home grown scripts and 'iozone -V' are
> passing.  I am open to suggestions for additional testing criteria.

Do you have performance numbers?

-- 
SUSE Labs, Novell Inc.
