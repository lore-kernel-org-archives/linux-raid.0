From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 08:26:39 -0500
Message-ID: <4D5E738F.2060509@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5BD678.2050200@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org>	<AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>	<4D5E7123.5020103@turmel.org> <AANLkTikxQaoJcNVH22_qaK_k7PAigOnV8QxCrM8s-iW=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikxQaoJcNVH22_qaK_k7PAigOnV8QxCrM8s-iW=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Simon Mcnair <simonmcnair@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/18/2011 08:21 AM, Roberto Spadim wrote:
> pci express x4 = 2.5*4gbps = 10gbps not?!

Subtract transfer overhead (Framing, ECC, addressing, etc) and it takes >8 bits to transfer 8 bits.  I haven't checked the spec, but it looks like just framing and ECC is +25%.
