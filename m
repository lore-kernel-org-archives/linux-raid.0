From: Phil Turmel <philip@turmel.org>
Subject: Re: [OT] C programming problem
Date: Wed, 7 Feb 2018 17:43:30 -0500
Message-ID: <ab1b1454-8226-ceab-55c8-e105fd0b3ca6@turmel.org>
References: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Wol,

Bug alert!

On 02/07/2018 02:46 PM, Wol's lists wrote:
> void main()
> {

>     blocks = logdisks * mirrors * disks;
>     array = (int *) malloc( sizeof(int) * blocks );
>     memset( &array, 0, blocks * sizeof(int) );
              ^^^^^^

Your 'array' variable is already a pointer.  You should not have
another address-of operator in front of it.  You are overwriting
your pointer and a bunch of static memory right after it, not
zeroing the area pointed to by 'array'.

Phil
