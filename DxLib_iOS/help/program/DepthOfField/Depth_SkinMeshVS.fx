// 頂点シェーダーの入力
struct VS_INPUT
{
	float4 Position        : POSITION ;			// 座標( ローカル空間 )
	int4   BlendIndices0   : BLENDINDICES0 ;	// スキニング処理用 Float型定数配列インデックス
	float4 BlendWeight0    : BLENDWEIGHT0 ;		// スキニング処理用ウエイト値
	float3 Normal          : NORMAL0 ;			// 法線( ローカル空間 )
	float4 Diffuse         : COLOR0 ;			// ディフューズカラー
	float4 Specular        : COLOR1 ;			// スペキュラカラー
	float4 TexCoords0      : TEXCOORD0 ;		// テクスチャ座標
} ;

// 頂点シェーダーの出力
struct VS_OUTPUT
{
	float4 ProjectionPosition : POSITION ;		// 射影座標
	float4 ViewPosition       : TEXCOORD0 ;		// ビュー座標
} ;



// C++ 側で設定する定数の定義
float4              cfProjectionMatrix[ 4 ] : register( c2  ) ;			// ビュー　　→　射影行列
float4              cfViewMatrix[ 3 ]       : register( c6  ) ;			// ワールド　→　ビュー行列
float4              cfLocalWorldMatrix[ 162 ] : register( c94 ) ;		// ローカル　→　ワールド行列


// main関数
VS_OUTPUT main( VS_INPUT VSInput )
{
	VS_OUTPUT VSOutput ;
	float4 lLocalWorldMatrix[ 3 ] ;
	float4 lWorldPosition ;


	// 複数のフレームのブレンド行列の作成
	lLocalWorldMatrix[ 0 ]  = cfLocalWorldMatrix[ VSInput.BlendIndices0.x + 0 ] * VSInput.BlendWeight0.x;
	lLocalWorldMatrix[ 1 ]  = cfLocalWorldMatrix[ VSInput.BlendIndices0.x + 1 ] * VSInput.BlendWeight0.x;
	lLocalWorldMatrix[ 2 ]  = cfLocalWorldMatrix[ VSInput.BlendIndices0.x + 2 ] * VSInput.BlendWeight0.x;

	lLocalWorldMatrix[ 0 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.y + 0 ] * VSInput.BlendWeight0.y;
	lLocalWorldMatrix[ 1 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.y + 1 ] * VSInput.BlendWeight0.y;
	lLocalWorldMatrix[ 2 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.y + 2 ] * VSInput.BlendWeight0.y;

	lLocalWorldMatrix[ 0 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.z + 0 ] * VSInput.BlendWeight0.z;
	lLocalWorldMatrix[ 1 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.z + 1 ] * VSInput.BlendWeight0.z;
	lLocalWorldMatrix[ 2 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.z + 2 ] * VSInput.BlendWeight0.z;

	lLocalWorldMatrix[ 0 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.w + 0 ] * VSInput.BlendWeight0.w;
	lLocalWorldMatrix[ 1 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.w + 1 ] * VSInput.BlendWeight0.w;
	lLocalWorldMatrix[ 2 ] += cfLocalWorldMatrix[ VSInput.BlendIndices0.w + 2 ] * VSInput.BlendWeight0.w;


	// 頂点座標変換 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++( 開始 )

	// ローカル座標をワールド座標に変換
	lWorldPosition.x = dot( VSInput.Position, lLocalWorldMatrix[ 0 ] ) ;
	lWorldPosition.y = dot( VSInput.Position, lLocalWorldMatrix[ 1 ] ) ;
	lWorldPosition.z = dot( VSInput.Position, lLocalWorldMatrix[ 2 ] ) ;
	lWorldPosition.w = 1.0f ;

	// ワールド座標をビュー座標に変換
	VSOutput.ViewPosition.x = dot( lWorldPosition, cfViewMatrix[ 0 ] ) ;
	VSOutput.ViewPosition.y = dot( lWorldPosition, cfViewMatrix[ 1 ] ) ;
	VSOutput.ViewPosition.z = dot( lWorldPosition, cfViewMatrix[ 2 ] ) ;
	VSOutput.ViewPosition.w = 1.0f ;

	// ビュー座標を射影座標に変換
	VSOutput.ProjectionPosition.x = dot( VSOutput.ViewPosition, cfProjectionMatrix[ 0 ] ) ;
	VSOutput.ProjectionPosition.y = dot( VSOutput.ViewPosition, cfProjectionMatrix[ 1 ] ) ;
	VSOutput.ProjectionPosition.z = dot( VSOutput.ViewPosition, cfProjectionMatrix[ 2 ] ) ;
	VSOutput.ProjectionPosition.w = dot( VSOutput.ViewPosition, cfProjectionMatrix[ 3 ] ) ;

	// 頂点座標変換 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++( 終了 )


	// 出力パラメータを返す
	return VSOutput ;
}
