From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Question: array locking, possible?
Date: Tue, 07 Feb 2006 14:26:13 -0500
Message-ID: <43E8F455.2020800@steeleye.com>
References: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Osicki <osk@admin.swisscom-mobile.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Osicki wrote:
> The problem now is how to prevent somebody on the other host from
> accidentally assembling the array. Because the result of doing so would
> be something from strange to catastrophic ;-)
> 
> To rephrase my question, is there any way to make it visible to the
> other host that the array is up an running on the this host?

I don't know how the storage boxes are attached to the servers, but you 
might be able to use SCSI reservations, if the storage supports them.

--
Paul
