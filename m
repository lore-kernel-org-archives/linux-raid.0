From: Brendan Conoboy <blc@redhat.com>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Thu, 28 Feb 2008 09:54:03 -0700
Message-ID: <47C6E72B.6060402@redhat.com>
References: <1204195554.16924.16.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204195554.16924.16.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: Franck Routier <franck.routier@axege.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Franck Routier wrote:
> I am under the impression that I will get better results with requests
> spread over 3 less effective arrays rather than two slightly more effive
> one.

Depends on your workload.  If you use a larger chunk size, regardless of 
raid layout, you can try to get each db transaction to only hit one 
spindle.  Seek time being a limiting factor, this may scale better when 
you have dozens of simultaneous requests.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
