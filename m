From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: [dm-crypt] Re: md-raid5, dm-crypt, alignment and readahead
Date: Wed, 12 Mar 2008 14:07:21 +0100
Message-ID: <bb145bd20803120607x7acfc308o4fefbcd925c21405@mail.gmail.com>
References: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com>
	 <bb145bd20803111647h13685bd8w4088138316667524@mail.gmail.com>
	 <20080312115520.GT21162@edu.joroinen.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080312115520.GT21162@edu.joroinen.fi>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dm-crypt@saout.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  > Ran quite a few tests and readahead at any layer but the top layer did
>  > not have any effect. This means that read ahead blocks will always be
>  > decrypted. Oh well ...
>  >
>
>  Just to make it clear.. with "top layer" you mean you set read ahead only for
>  the dm-crypt device and NOT for the md-raid and/or physical sdX devices?

Exactly.

C.
