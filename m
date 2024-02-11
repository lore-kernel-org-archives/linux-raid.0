Received: from sonic305-20.consmr.mail.gq1.yahoo.com (sonic305-20.consmr.mail.gq1.yahoo.com [98.137.64.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C955C613
	for <linux-raid@vger.kernel.org>; Sun, 11 Feb 2024 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.64.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707671597; cv=none; b=j5FKZy0hI6ZMvRyckPnGfblXtYX6edq5jn1BiRU9VL8M5Pi3UqxMvbqdtcb7NEc5PhDPBwfj3aNqnwHOSgdsROfGsHmtuLppif4aCrKNJiglRNpsgyoNssAI1JmCN1ufdDpRS0vPIbH4O2zN1iQ+OkFPequoIPzkBL5SDVRWaMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707671597; c=relaxed/simple;
	bh=UslXWps3O7oQ4tGTS5HTl3nW82XdxA+kXUZ/GqWrDhA=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type:
	 References; b=ekgkT12xmKg/Fp+mR488by60RIKMCtndc8fWJwN9zaawz019LLDDAyyMnxVbxwRnqQOa3IYLpxXEJ2Zsx+aLX1RE4+RwDYGiJOTw6G67BKrAN8KNwRfbH3I3atS4oicOF53njcwP0w+dJLBTlzQnTdNPFLBxiROv3rjDQtQLBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.ca; spf=pass smtp.mailfrom=yahoo.ca; dkim=pass (2048-bit key) header.d=yahoo.ca header.i=@yahoo.ca header.b=hocosffB; arc=none smtp.client-ip=98.137.64.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.ca header.i=@yahoo.ca header.b="hocosffB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.ca; s=s2048; t=1707671595; bh=1yu1yJwAjPK4wajMl2lOCan68x5sxmxmHE8cozed2To=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=hocosffBHNMWbjoOlmUprKz5Ql9OBZLMvBYHkcD7k/bmwzDudscdwZKYCxRvpyifFyTZTYsoqKXw92bhC6ikCl5PhoriHWRw/Eok7DvkHnJpXcEbCUrJaL6zE25tsUQPldkvH2h8rxnT9W+azkckgtX/taHiUc/+gSjQI7vp7LntOzw6jM1kc5Sj8Y5NDWozsHafrNLTFWdHU3fag6hCr+m2uixHVl7cEoVhGsMda4bdYmArKkjMkqTnfOsvCsY6ulxHc4PcMi/Pe6jhgUxWU0ZglbYQ4qX/DOcNPl/qv+GlZugOG1XAzWvMFP/+xLKmzn1gGeefsED9d6xLYnogvw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1707671595; bh=GaoSiB1xNHxnenZW482m4bz5+EjBNw3h61alfVG7BZC=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=EYa8yErhWOM2FcO+3kDKRTqAseZ3r6asv4Q9tySuAPbbxfm5SpGOoVmGLGh6MUecwkslTa5ASzRjhSkJKMVc+7bQY8WlEu79uoYlaYPWmNS2G9iwrTmaqhH2w0Yd9P0pwfd9m5bIipjrHWsCKUqdtbr/5eNAPFR/Ay12nZfiW2sbKVy0lueWIgEHC6A4fy8A5SZN4J3i5eO6SNPjfKAvo6MmKNGKfahNeFhM9sh+jqarphIzrsQyigDD4t0XRfD3filPlD/ovnHLKs0oygcBNNR2XYgnHWz0t4cCuubiglcugEFQz6EPOfaORYvMGILrAlsCGuL/18/EfOmtk6Rmgg==
X-YMail-OSG: kGmTAAgVM1n0s4yc7vY3.eOhXmmnKg6uB70iIOeqmJdA2sNq05h_CXVx8DYDKzC
 0jIvDnf6dCFilLVGzPu3Rkyql0xWt7eX8xiaNGu4LH_.n0tCJs.BN.F9PJkmrxsVHzDQof1fUbH7
 n89CP7_Gex2Tl4mitSMGNm3IplWbC4NJHg1pOX_Lms9sr4AjVTE_fhUC2VQQgwftgqbUJVvy5r4o
 2PT_veyakEwH6Evjxww4yKAoMl7SFebUfJze.pFtGG_Uf.dXO7ambbshZ8_Zx2ENb1AviLlj40ym
 HvkxegWwSuQrrhgy1N1DyRlxMSd6ulz0m4mCXnD5Yr9s8_1j8n7Nj3y499dXUovj_qG5Kxkf21Di
 UxO855Hi5iz0t6bmsz2_5FNUF2CpiqtgoLJxhHqcJCM_FKqFQ7Q5XW9T6bTknO1ISXpRutDZJ6uB
 .z3G.u7fgbOlJd3nq49bqSDZZg.J.KCemj6sqChZyJxdw9MuDRIKLYtBOTGOHlEvMANpEs64bR7l
 C0HhTrxmekv_1KCBCUK1GvYtRRk9sFa1_QY7vR2hhAvgGVykQOM04eQZdcuelxUjIn_Zf4vhX14o
 LUFdyyw8djGLSSbNzUyD11LAvqY2Xa3vLV5wD1kOCcmXB3AUAySrCuslZ3p4XAH4STwpvnaPwwSO
 X0q88e1woOsvchNleGzGnMpuvhAqzCKe0B5RFoEg7XUf_R8a1l3QWdExa_zJi61FtJU_EFdpvHsL
 _mqsql2uDK.Lq3i6GCYvYOma5wNXbkzC3X1UZ7wyCnS0vhf9_2DMk_X_AlO6J7tdR.eAMwCDSFio
 uvMH9T5iBRKOU9plomkhoZiRCJsY24XrsctZIG2fVwE6pfiv7WFYHQqNvERD6lbqO_LH_e8kN0Qj
 uvCA6aPrtI75HlH6XNMCKLDhgE75eCccrDs0UmlEgVyZOANJ2XYkUDv81O8qco.AdMi4WYaBeTx3
 ktYRwF0Y4eWxlFzx2TkSESinORCwtOQST.GZRi6qRzzGrEJIMjRIdqGMWLsgqpJtxSBBLon8ai6X
 uYMKzAqvQKWxtbWz0nPPzFbKIbAxoD0AeD2hlRuSbxaBkYVQ9DbxTZTEQttXVH0YJ4MG1SMRGGUT
 n72NUSbA4o4x4ic5XXuEQX0tkj9QsdK9PRMHzD48vQzIeH.RX6v5e33081minpoubaAs9mFlJLt2
 xZDAoLYsbaVnCGlureTQ403Uy5ouacbtSipP.RsB80LZFLyFyPEAIMATfVmqW7MqCtqhSqhwqwkb
 0F.tk5vngmnMEEqEOYNDKnxWTtFNzCWogqN_IGiESxeuLEqXKIy44VXBXnmvmONaboyzt26kPIFL
 cxC4uCl0nLApkW417D1BJ3vmI2N_6aTrtXv88x3z35EvOm079_B91w3Cjuf6nEv.yaIuR3DZ7Rxv
 iJmiacCvEPsQ8WaQ11F2TGj7z7e6.Pdh1v5vOriSjLy24sFANNMs3WlBoIHoP75BdWxPgxMjTAZD
 ZzUp4iE1UgHpvlQ7YMbzB9pMTBHI887INOd.0Fza_XQ34TV_FBULkzq32LQzfkQtkDTUd8h2KcAM
 TiuNVHyw4ScQYh8WbaHlU.sWVpuYn0PDxAEthNcBJGueksgdZhuejTtxsHO0AzJa04RUzvWkxaMM
 A8TcXfUZFabOlq3oFtAagq3nO1xorshqiRT1CRljaGKMhGpIWy2qdhz2_q4mAQ7YmN8syCTkBmp6
 5AWXHVgeCeOXDzV3i7g7GLN_rZaC_hXYW1qLQqQppmbpsUJaCBhh1h_qf40pVAYJ9p0OcRCSgmaY
 PlaDLBKkOG0nUKTr_QtR_M2AioLBxwSlyxxvPvFyJJGPV8M7vVEsgKUmolOxHUw9bRjBY9of2e_U
 fTQy7DwMljAM7ccuRejKRVXX2Lhrwiy5lumTWJveCzW.FzaiTlMu8y7NkXQuAf1LiUKye_GC5unD
 jAzvBk8oYydC9EE23.E0AxR2Mcb7odW3I9s3RIt4ZKKtxE6fU9Ile6eke46NcaFYoWeYi3ps8j96
 cghtNeQaeuNa_3BKcctm.aKjnShF.jBpy6aaRyVRgPUqOUfuKFOjBAZl776JHDOyi1fVzD4jlC9V
 wOBWxqqZPdO59PAegsQ9r6f647QrbGHDsIOHHMIO6ujzM3Ay3LH_o2c8Q18y49rKcrwzhi3290cz
 GAlw0tz13X4Mf236JuU7crQzsihcHmc2JLuNAvJ1oYTu2pHhgGYSjsBPT5Bn4vsUjUfaw0RGZJnz
 TUicUDoDSyyhB.mWln9YyhpYY.YUpxdJiFBmHrOIZNN74qw--
X-Sonic-MF: <earl.chew@yahoo.ca>
X-Sonic-ID: 5c2d6b23-dbf5-493d-910f-bcdddc01d955
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Sun, 11 Feb 2024 17:13:15 +0000
Received: by hermes--production-gq1-5c57879fdf-qprqq (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ff4c5eee16a523e4bc8a34e50812745f;
          Sun, 11 Feb 2024 17:13:12 +0000 (UTC)
Received: from portal.lan ([192.168.1.2]:57072 helo=[192.168.1.74])
	by postbox.timberdragon.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95.0)
	(envelope-from <earl.chew@yahoo.ca>)
	id 1rZDOB-0007Rd-67
	for linux-raid@vger.kernel.org;
	Sun, 11 Feb 2024 09:13:11 -0800
Message-ID: <4325d3bb-a6d8-4d13-95b6-4f29db1a5206@yahoo.ca>
Date: Sun, 11 Feb 2024 09:13:10 -0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-CA
From: Earl Chew <earl.chew@yahoo.ca>
To: linux-raid@vger.kernel.org
Subject: mdadm --create vs --update with --homehost <ignore>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
References: <4325d3bb-a6d8-4d13-95b6-4f29db1a5206.ref@yahoo.ca>
X-Mailer: WebService/1.1.22077 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Processing of --update blocks removal of homehost from existing arrays even though
new arrays can be created without an embedded homehost.

Is there any concern allowing --update to remove of homehost from existing arrays?

The code for init_super1() shows that when creating a new array, it is possible to exclude homehost:

https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super1.c#n1656

	if (homehost &&
	    strchr(name, ':') == NULL &&
	    strlen(homehost) + 1 + strlen(name) < 32) {
		strcpy(sb->set_name, homehost);
		strcat(sb->set_name, ":");
		strcat(sb->set_name, name);
	} else {
		int namelen;

		namelen = min((int)strlen(name),
			      (int)sizeof(sb->set_name) - 1);
		memcpy(sb->set_name, name, namelen);
		memset(&sb->set_name[namelen], '\0',
		       sizeof(sb->set_name) - namelen);
	}

The code for update_super1() shows that while it is possible to use --update to modify
homehost for an array, it is not possible to remove homehost from an existing array:

https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super1.c#n1196

	if (update == UOPT_HOMEHOST && homehost) {
		/*
		 * Note that 'homehost' is special as it is really
		 * a "name" update.
		 */
		char *c;
		update = UOPT_NAME;
		c = strchr(sb->set_name, ':');
		if (c)
			snprintf(info->name, sizeof(info->name), "%s", c + 1);
		else
			snprintf(info->name, sizeof(info->name), "%s",
				 sb->set_name);
	}

Earl
