From: Phil Turmel <philip@turmel.org>
Subject: Re: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Tue, 21 Mar 2017 13:08:44 -0400
Message-ID: <2bdccf88-7a0c-0a5a-e418-818b7343f867@turmel.org>
References: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
 <0a6e4a82-665c-6e62-293f-151e41c67842@turmel.org>
 <CAJ0QwkKAVLh7+kV_GsEL4O5hA+Pj=Y9sE_CBbWJJqDyA+gVqpA@mail.gmail.com>
 <CAJ0QwkKuSKzE7_4h1aUA4XMyNAAdmFR4J6z+Z_vW5nsW3OcZtw@mail.gmail.com>
 <c3ae0e4d-dccc-9cb4-72b0-28a1bde3c752@turmel.org>
 <CAJ0QwkKG8_dCzTBYEPm5CpqWMQwM=f8YBAYtatNh=9U_7ygdnA@mail.gmail.com>
 <f0536882-3a0b-b43c-317d-691d82c6923f@turmel.org>
 <CAJ0Qwk+-Zz7RM8p7Ehy8aGuf+CQkPpbnBOaGNN77bP8cA5K9qg@mail.gmail.com>
 <CAJ0QwkKbYuVFdkRn0ggFOqudQswNYnF+koVLSxQ_XTPQnLkhOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ0QwkKbYuVFdkRn0ggFOqudQswNYnF+koVLSxQ_XTPQnLkhOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Olivier Swinkels <olivier.swinkels@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Olivier,

{ Sorry, lot of work travel lately /-: }

On 03/17/2017 03:25 PM, Olivier Swinkels wrote:

> Hi Phil,
> 
> Did you already have time to look at the results of the fsck check
> and ext2/3/4 superblock search?

Well, there are a few superblock candidates in your output, the lines
showing ".X4R" for the first four bytes, but that converts to a
timestamp of Sat, 14 Sep 2013 12:35:24 GMT.

Ewww.

> I would really like some feedback, as I'm quite out of ideas.

You should look at the other devices, but with that timestamp, the odds
look very poor.

Sorry.  Possibly try photorec or similar raw data recovery tools.

Phil
