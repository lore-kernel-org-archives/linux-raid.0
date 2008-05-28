From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Thu, 29 May 2008 08:03:34 +1200
Message-ID: <483DBA96.4010105@sauce.co.nz>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483D7CE8.4000600@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Snook <csnook@redhat.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Snook wrote:

> course, you'd want to use a single SATA controller with a known good NCQ 
> implementation, and hard drives known to not do stupid things like 
> disable readahead when NCQ is enabled.

Do you have a list of drives that do disable readahead on NCQ?

Regards,

Richard
