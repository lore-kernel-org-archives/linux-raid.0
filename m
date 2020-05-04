From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: RAID 1 | Restore based on Image of /dev/sda
Date: Mon, 4 May 2020 13:52:59 +0200
Message-ID: <fe7f04ef-0dfe-8c89-0b4d-cc3d6bebcffe@peter-speer.de>
References: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
 <5EAFF763.2000906@youngman.org.uk>
 <58659d1e-bcce-553c-fe68-52d075422252@peter-speer.de>
 <20200504113652.GA22487@vault.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200504113652.GA22487@vault.lan>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04.05.20 13:36, Johannes Truschnigg wrote:
> Hi Steffi,
> 
> On Mon, May 04, 2020 at 01:26:35PM +0200, Stefanie Leisestreichler wrote:
>> [...]
>> Thanks, Wol, especially for the hint with the GUIDs, will keep this in mind.
>> If ever using it again - maybe in case of a quick temporary replacement in
>> the original computer - I will wipe it with zeros before.
>>
>> The partition layout will be cloned using sfdisk.
> 
> When dealing with GPT partitions, you might want to consider using `sgdisk`
> instead. It features -G|--randomize-guids and will be able to clone a GPT
> table from one drive to another in one go, without you having to iron out
> UUID-related problems that "naive" cloning (which I believe `sfdisk` will
> perform) will introduce.
> 
> Hth!
> 

This also found its way in my private wiki, thanks!
