From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Wed, 4 Oct 2017 15:33:02 -0400
Message-ID: <22997.14190.22782.85916@quad.stoffel.home>
References: <22997.8664.67459.119616@quad.stoffel.home>
        <576ad3c5-1c23-39d3-1631-d18ed0a3323a@gmail.com>
        <22997.13125.28017.852313@quad.stoffel.home>
        <de82859a-a7dc-a8d6-6ce2-52e7b1163b99@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de82859a-a7dc-a8d6-6ce2-52e7b1163b99@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jes" == Jes Sorensen <jes.sorensen@gmail.com> writes:

Jes> Yikes!
>> 
>> Can you explain please?  I added in the c.force since that's the value
>> set by the -f (--force) flag when you call mdadm from the command
>> line.

Jes> The broken indentation

Heh, I'm working on fixing it.  Sorry!  
