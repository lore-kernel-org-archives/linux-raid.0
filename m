From: "David Rees" <drees76@gmail.com>
Subject: Re: Multiple Disk Failure Recovery
Date: Sat, 14 Oct 2006 23:35:31 -0700
Message-ID: <72dbd3150610142335l3920e72ev8756ce1e36b70b5a@mail.gmail.com>
References: <45319CFC.4050708@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45319CFC.4050708@mit.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lane Brooks <lbrooks@mit.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/14/06, Lane Brooks <lbrooks@mit.edu> wrote:
> I am wondering if there is a way to cut my losses with these bad sectors
> and have it recover what it can so that I can get my raid array back to
> functioning.  Right now I cannot get a spare disk recovery to finish
> because these bad sectors.  Is there a way to force as much recovery as
> possible so that I can replace this newly faulty drive?

One technique is to use ddrescue to create an image of the failing
drive(s) (I would image all drives if possible) and use those images
to try to retrieve your data.

-Dave
