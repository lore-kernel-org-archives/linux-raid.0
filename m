From: Alessandro Baretta <alexbaretta@gmail.com>
Subject: Re: Linear mode: array size is less than sum of sizes
Date: Wed, 6 Jan 2010 00:02:47 +0100
Message-ID: <f4143ac21001051502u5e4d0a1cu541ddc8527cc5b82@mail.gmail.com>
References: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>
	<4B439BC8.1030908@anonymous.org.uk> <4B439D5E.2010107@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B439D5E.2010107@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 5, 2010 at 9:13 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 05/01/2010 20:06, John Robinson wrote:
>
> Try playing with dm instead of md - `man dmsetup` suggests it may be able to
> do a linear concatenation in single-sector amounts...


Too late... I did it with md. But thanks for the suggestion: yes, this
was the right way to do this.

Alex
