From: Michael Fritscher <michael@fritscher.net>
Subject: Re: [OT] C programming problem
Date: Wed, 7 Feb 2018 21:00:48 +0100
Message-ID: <46a82977-bb58-8ac5-bbde-ba027339f31e@fritscher.net>
References: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Content-Language: de-LU
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

> main.c:20:5: warning: incompatible implicit declaration of built-in
> function ‘memset’ [enabled by default]
>     memset( &array, 0, blocks * sizeof(int) );

at least my compiler says something about
> a.c:21:5: note: include ‘<string.h>’ or provide a declaration of ‘memset’

And yes, the first recipe does indeed help :-P

Best regards,
Michael Fritscher
